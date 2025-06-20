# frozen_string_literal: true

module BankAccountValidations
  extend ActiveSupport::Concern

  included do
    alias_attribute :bank_code, :bank_number

    validate :validate_bank_code
    validate :validate_branch_code
    validate :validate_account_number, if: -> {
      production_only_models = ["JordanBankAccount", "BahrainBankAccount", "TunisiaBankAccount", "OmanBankAccount",
                               "NorwayBankAccount", "CzechRepublicBankAccount", "GuatemalaBankAccount", "NigerBankAccount",
                               "CostaRicaBankAccount", "NorthMacedoniaBankAccount", "GibraltarBankAccount", "AngolaBankAccount",
                               "AlbaniaBankAccount", "MoroccoBankAccount", "BulgariaBankAccount", "CoteDIvoireBankAccount",
                               "HungaryBankAccount", "AzerbaijanBankAccount", "EuropeanBankAccount", "SwedenBankAccount",
                               "BotswanaBankAccount", "PolandBankAccount", "RomaniaBankAccount", "SwissBankAccount",
                               "LiechtensteinBankAccount", "BeninBankAccount", "BosniaAndHerzegovinaBankAccount",
                               "UaeBankAccount", "MonacoBankAccount", "DenmarkBankAccount", "SerbiaBankAccount"]
      production_only_models.include?(self.class.name) ? Rails.env.production? : true
    }
  end

  def routing_number
    # Some models don't have routing numbers
    no_routing_models = ["IsraelBankAccount", "TunisiaBankAccount", "EuropeanBankAccount",
                        "NorwayBankAccount", "CzechRepublicBankAccount", "NigerBankAccount",
                        "CostaRicaBankAccount", "GibraltarBankAccount", "BulgariaBankAccount",
                        "CoteDIvoireBankAccount", "HungaryBankAccount", "SwedenBankAccount",
                        "PolandBankAccount", "RomaniaBankAccount", "LiechtensteinBankAccount",
                        "BeninBankAccount", "UaeBankAccount", "MonacoBankAccount", "DenmarkBankAccount"]
    return nil if no_routing_models.include?(self.class.name)

    if respond_to?(:branch_code) && branch_code.present?
      case self.class.name
      when "JapanBankAccount", "TrinidadAndTobagoBankAccount"
        "#{bank_code}#{branch_code}"
      else
        "#{bank_code}-#{branch_code}"
      end
    else
      "#{bank_code}"
    end
  end

  def account_number_visual
    # Some countries show the country code before the account number
    country_prefix_models = ["JordanBankAccount", "BahrainBankAccount", "TunisiaBankAccount",
                             "AzerbaijanBankAccount", "EuropeanBankAccount", "NigeriaBankAccount",
                             "IsraelBankAccount", "MauritiusBankAccount", "AngolaBankAccount",
                             "NorthMacedoniaBankAccount"]

    if country_prefix_models.include?(self.class.name)
      "#{country}******#{account_number_last_four}"
    else
      "******#{account_number_last_four}"
    end
  end

  def to_hash
    # Some models don't have routing numbers
    hash = {
      account_number: account_number_visual,
      bank_account_type:
    }

    # Only add routing_number if it exists
    if routing_number.present?
      hash[:routing_number] = routing_number
    end

    hash
  end

  private
    def validate_bank_code
      return unless self.class.const_defined?(:BANK_CODE_FORMAT_REGEX, false)
      return if self.class.const_get(:BANK_CODE_FORMAT_REGEX).match?(bank_code.to_s)
      errors.add :base, "The bank code is invalid."
    end

    def validate_branch_code
      return unless self.class.const_defined?(:BRANCH_CODE_FORMAT_REGEX, false)
      return if self.class.const_get(:BRANCH_CODE_FORMAT_REGEX).match?(branch_code.to_s)
      errors.add :base, "The branch code is invalid."
    end

                    def validate_account_number
      # Some models use IBAN validation instead of regex
      iban_countries = ["KuwaitBankAccount", "IsraelBankAccount", "PakistanBankAccount",
                       "EgyptBankAccount", "JordanBankAccount", "TurkeyBankAccount",
                       "BahrainBankAccount", "TunisiaBankAccount", "SaudiArabiaBankAccount",
                       "NorwayBankAccount", "CzechRepublicBankAccount", "NigerBankAccount",
                       "CostaRicaBankAccount", "GibraltarBankAccount",
                       "BulgariaBankAccount", "CoteDIvoireBankAccount", "HungaryBankAccount",
                       "AzerbaijanBankAccount", "EuropeanBankAccount", "SwedenBankAccount",
                       "PolandBankAccount", "RomaniaBankAccount", "SwissBankAccount",
                       "LiechtensteinBankAccount", "BeninBankAccount", "UaeBankAccount",
                       "MonacoBankAccount", "DenmarkBankAccount", "SerbiaBankAccount", "MauritiusBankAccount"]

      if iban_countries.include?(self.class.name)
        return if Ibandit::IBAN.new(account_number_decrypted).valid?
        errors.add :base, "The account number is invalid."
        return
      end

      return unless self.class.const_defined?(:ACCOUNT_NUMBER_FORMAT_REGEX, false)
      return if self.class.const_get(:ACCOUNT_NUMBER_FORMAT_REGEX).match?(account_number_decrypted.to_s)

      errors.add :base, "The account number is invalid."
    end
end

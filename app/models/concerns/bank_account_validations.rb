# frozen_string_literal: true

module BankAccountValidations
  extend ActiveSupport::Concern

  included do
    alias_attribute :bank_code, :bank_number

    validate :validate_bank_code
    validate :validate_branch_code
    validate :validate_account_number
  end

  def routing_number
    # Israel bank account doesn't have a routing number
    if self.class.name == "IsraelBankAccount"
      return nil
    end

    if respond_to?(:branch_code) && branch_code.present?
      case self.class.name
      when "JapanBankAccount"
        "#{bank_code}#{branch_code}"
      else
        "#{bank_code}-#{branch_code}"
      end
    else
      "#{bank_code}"
    end
  end

  def account_number_visual
    "******#{account_number_last_four}"
  end

  def to_hash
    {
      routing_number:,
      account_number: account_number_visual,
      bank_account_type:
    }
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
      if ["KuwaitBankAccount", "IsraelBankAccount"].include?(self.class.name)
        return if Ibandit::IBAN.new(account_number_decrypted).valid?
        errors.add :base, "The account number is invalid."
        return
      end

      return unless self.class.const_defined?(:ACCOUNT_NUMBER_FORMAT_REGEX, false)
      return if self.class.const_get(:ACCOUNT_NUMBER_FORMAT_REGEX).match?(account_number_decrypted.to_s)

      errors.add :base, "The account number is invalid."
    end
end

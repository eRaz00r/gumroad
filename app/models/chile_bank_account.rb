# frozen_string_literal: true

class ChileBankAccount < BankAccount
  include ChileBankAccount::AccountType
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "CL"
  BANK_CODE_FORMAT_REGEX = /\A[0-9]{3}\z/
  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{5,25}\z/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  before_validation :set_default_account_type, on: :create, if: ->(chile_bank_account) { chile_bank_account.account_type.nil? }
  validates :account_type, inclusion: { in: AccountType.all }

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::CHL.alpha2
  end

  def currency
    Currency::CLP
  end

  private
    def set_default_account_type
      self.account_type = AccountType::CHECKING
    end
end

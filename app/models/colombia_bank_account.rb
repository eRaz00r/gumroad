# frozen_string_literal: true

class ColombiaBankAccount < BankAccount
  include ColombiaBankAccount::AccountType
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "CO"
  BANK_CODE_FORMAT_REGEX = /\A[0-9]{3}\z/
  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{9,16}\z/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  before_validation :set_default_account_type, on: :create, if: ->(bank_account) { bank_account.account_type.nil? }
  validates :account_type, inclusion: { in: AccountType.all }

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::COL.alpha2
  end

  def currency
    Currency::COP
  end

  private
    def set_default_account_type
      self.account_type = ColombiaBankAccount::AccountType::CHECKING
    end
end

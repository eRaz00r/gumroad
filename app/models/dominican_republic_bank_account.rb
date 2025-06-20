# frozen_string_literal: true

class DominicanRepublicBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "DO"
  BANK_CODE_FORMAT_REGEX = /^\d{1,3}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{1,28}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  validates :bank_code, presence: true
  validates :account_number, presence: true

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::DOM.alpha2
  end

  def currency
    Currency::DOP
  end
end

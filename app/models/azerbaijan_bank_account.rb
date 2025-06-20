# frozen_string_literal: true

class AzerbaijanBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "AZ"
  BANK_CODE_FORMAT_REGEX = /^\d{6}$/
  BRANCH_CODE_FORMAT_REGEX = /^\d{6}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :BRANCH_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::AZE.alpha2
  end

  def currency
    Currency::AZN
  end
end

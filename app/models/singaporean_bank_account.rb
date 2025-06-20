# frozen_string_literal: true

class SingaporeanBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "SG"

  BANK_CODE_FORMAT_REGEX = /\A[0-9]{4}\z/
  private_constant :BANK_CODE_FORMAT_REGEX

  BRANCH_CODE_FORMAT_REGEX = /\A[0-9]{3}\z/
  private_constant :BRANCH_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{6,19}\z/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::SGP.alpha2
  end

  def currency
    Currency::SGD
  end
end

# frozen_string_literal: true

class UzbekistanBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "UZ"
  BANK_CODE_FORMAT_REGEX = /^([a-zA-Z0-9]){8,11}$/
  BRANCH_CODE_FORMAT_REGEX = /^([0-9]){5}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{5,20}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :BRANCH_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::UZB.alpha2
  end

  def currency
    Currency::UZS
  end
end

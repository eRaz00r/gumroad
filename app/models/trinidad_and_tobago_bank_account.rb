# frozen_string_literal: true

class TrinidadAndTobagoBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "TT"
  BANK_CODE_FORMAT_REGEX = /\A[0-9]{3}\z/
  BRANCH_CODE_FORMAT_REGEX = /\A[0-9]{5}\z/
  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{1,17}\z/
  private_constant :BANK_CODE_FORMAT_REGEX, :BRANCH_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::TTO.alpha2
  end

  def currency
    Currency::TTD
  end
end

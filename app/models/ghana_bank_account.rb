# frozen_string_literal: true

class GhanaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "GH"

  BANK_CODE_FORMAT_REGEX = /\A[0-9]{6}\z/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{8,20}\z/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::GHA.alpha2
  end

  def currency
    Currency::GHS
  end
end

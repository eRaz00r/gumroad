# frozen_string_literal: true

class MauritiusBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "MU"
  BANK_CODE_FORMAT_REGEX = /^[a-zA-Z0-9]{8,11}?$/
  private_constant :BANK_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::MUS.alpha2
  end

  def currency
    Currency::MUR
  end
end

# frozen_string_literal: true

class PanamaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "PA"
  BANK_CODE_FORMAT_REGEX = /^[A-Z]{4}PAPA[A-Z0-9]{3}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{1,18}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::PAN.alpha2
  end

  def currency
    Currency::USD
  end
end

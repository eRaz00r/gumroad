# frozen_string_literal: true

class AngolaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "AO"
  BANK_CODE_FORMAT_REGEX = /^([0-9a-zA-Z]){8,11}$/
  private_constant :BANK_CODE_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::AGO.alpha2
  end

  def currency
    Currency::AOA
  end
end

# frozen_string_literal: true

class ArmeniaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "AM"
  BANK_CODE_FORMAT_REGEX = /^[0-9A-Za-z]{8,11}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{11,16}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def routing_number
    bank_code.to_s
  end

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::ARM.alpha2
  end

  def currency
    Currency::AMD
  end
end

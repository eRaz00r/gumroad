# frozen_string_literal: true

class KoreaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "KR"

  BANK_CODE_FORMAT_REGEX = /\A[A-Za-z]{4}KR[A-Za-z0-9]{2,5}\z/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{11,15}\z/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::KOR.alpha2
  end

  def currency
    Currency::KRW
  end
end

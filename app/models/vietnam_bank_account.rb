# frozen_string_literal: true

class VietnamBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "VN"

  BANK_CODE_FORMAT_REGEX = /\A[0-9]{8}\z/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /\A[0-9]{1,17}\z/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::VNM.alpha2
  end

  def currency
    Currency::VND
  end
end

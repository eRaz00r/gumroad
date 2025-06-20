# frozen_string_literal: true

class JamaicaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "JM"
  BANK_CODE_FORMAT_REGEX = /^\d{3}$/
  BRANCH_CODE_FORMAT_REGEX = /^\d{5}$/
  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{1,18}$/
  private_constant :BANK_CODE_FORMAT_REGEX, :BRANCH_CODE_FORMAT_REGEX, :ACCOUNT_NUMBER_FORMAT_REGEX

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::JAM.alpha2
  end

  def currency
    Currency::JMD
  end
end

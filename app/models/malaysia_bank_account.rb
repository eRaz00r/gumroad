# frozen_string_literal: true

class MalaysiaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "MY"

  BANK_CODE_FORMAT_REGEX = /^([0-9a-zA-Z]){8,11}$/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /^([0-9]){5,17}$/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  validate :validate_account_number, if: -> { Rails.env.production? }

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::MYS.alpha2
  end

  def currency
    Currency::MYR
  end
end

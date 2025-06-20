# frozen_string_literal: true

class NigeriaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "NG"

  BANK_CODE_FORMAT_REGEX = /^([0-9a-zA-Z]){8,11}$/
  private_constant :BANK_CODE_FORMAT_REGEX

  ACCOUNT_NUMBER_FORMAT_REGEX = /^\d{10}$/
  private_constant :ACCOUNT_NUMBER_FORMAT_REGEX

  validate :validate_account_number, if: -> { Rails.env.production? }

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::NGA.alpha2
  end

  def currency
    Currency::NGN
  end

  def account_number_visual
    "#{country}******#{account_number_last_four}"
  end
end

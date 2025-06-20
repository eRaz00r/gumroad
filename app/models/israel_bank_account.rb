# frozen_string_literal: true

class IsraelBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "IL"

  validate :validate_account_number, if: -> { Rails.env.production? }

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::ISR.alpha2
  end

  def currency
    Currency::ILS
  end

  def account_number_visual
    "#{country}******#{account_number_last_four}"
  end
end

# frozen_string_literal: true

class TunisiaBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "TN"

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::TUN.alpha2
  end

  def currency
    Currency::TND
  end
end

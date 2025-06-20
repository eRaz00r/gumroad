# frozen_string_literal: true

class NorwayBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "NO"

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    Compliance::Countries::NOR.alpha2
  end

  def currency
    Currency::NOK
  end
end

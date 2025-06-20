# frozen_string_literal: true

class EuropeanBankAccount < BankAccount
  include BankAccountValidations

  BANK_ACCOUNT_TYPE = "EU"

  def bank_account_type
    BANK_ACCOUNT_TYPE
  end

  def country
    ISO3166::Country[account_number_decrypted[0, 2]].alpha2
  end

  def currency
    Currency::EUR
  end
end

Money.rounding_mode = BigDecimal::ROUND_HALF_UP
Money.use_i18n = false

curr = {
    :priority=>100,
    :iso_code=>"CHF",
    :name=>"Swiss Franc",
    :symbol=>"Fr",
    :alternate_symbols=>["SFr", "CHF"],
    :subunit=>"Rappen",
    :subunit_to_unit=>100,
    :symbol_first=>true,
    :html_entity=>"",
    :decimal_mark=>".",
    :thousands_separator=>"'",
    :iso_numeric=>"756",
    :smallest_denomination=>5
}

Money::Currency.register(curr)
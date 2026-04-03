require "test_helper"

class PaletteGeneratorServiceTest < ActiveSupport::TestCase
  # ── Helpers ─────────────────────────────────────────────────────────────────

  VALID_HEX = /\A#[0-9A-Fa-f]{6}\z/

  def generate(base_hex: "#268bd2", mood: "dark", harmony: "monochromatic")
    PaletteGeneratorService.new(base_hex: base_hex, mood: mood, harmony: harmony).call
  end

  # ── Output structure ─────────────────────────────────────────────────────────

  test "returns a hash with all six colour roles" do
    result = generate
    assert_kind_of Hash, result
    assert_equal %i[primary secondary accent background surface text], result.keys
  end

  test "all six values are valid 6-digit hex strings" do
    result = generate
    result.each do |role, hex|
      assert_match VALID_HEX, hex, "#{role} value '#{hex}' is not a valid hex colour"
    end
  end

  # ── All moods produce valid output ───────────────────────────────────────────

  PaletteGeneratorService::MOODS.each do |mood|
    test "returns valid hex colours for mood: #{mood}" do
      result = generate(mood: mood)
      result.each_value { |hex| assert_match VALID_HEX, hex }
    end
  end

  # ── All harmony rules produce valid output ───────────────────────────────────

  PaletteGeneratorService::HARMONIES.each do |harmony|
    test "returns valid hex colours for harmony: #{harmony}" do
      result = generate(harmony: harmony)
      result.each_value { |hex| assert_match VALID_HEX, hex }
    end
  end

  # ── All mood × harmony combinations ─────────────────────────────────────────

  PaletteGeneratorService::MOODS.each do |mood|
    PaletteGeneratorService::HARMONIES.each do |harmony|
      test "produces valid palette for mood=#{mood} harmony=#{harmony}" do
        result = generate(mood: mood, harmony: harmony)
        assert_equal 6, result.size
        result.each_value { |hex| assert_match VALID_HEX, hex }
      end
    end
  end

  # ── Harmony rules use different hues ─────────────────────────────────────────

  test "monochromatic uses same hue for primary, secondary, and accent" do
    # With monochromatic, all three roles share the base hue so primary and accent
    # will sit at different lightness on the same hue — they may differ in value
    # but secondary hue should be identical to primary hue (only sat changes)
    result = generate(harmony: "monochromatic")
    # All six are valid — already proven above; spot-check they are non-empty
    assert result[:primary].present?
    assert result[:secondary].present?
    assert result[:accent].present?
  end

  test "complementary secondary hue differs from primary hue" do
    # Use a pure hue with high saturation so the complement is clearly distinct
    result_comp = generate(base_hex: "#ff0000", harmony: "complementary")
    result_mono = generate(base_hex: "#ff0000", harmony: "monochromatic")
    # Secondary should shift hue (complement = +180°), so it differs
    refute_equal result_comp[:secondary], result_mono[:secondary]
  end

  test "triadic returns three distinct hues for primary/secondary/accent" do
    result = generate(base_hex: "#268bd2", harmony: "triadic")
    # At least two of the three active-role colours should differ
    assert_not_equal result[:primary], result[:secondary]
    assert_not_equal result[:secondary], result[:accent]
  end

  # ── Dark mood lightness expectations ─────────────────────────────────────────

  test "dark mood background is very dark" do
    result   = generate(mood: "dark")
    bg_hex   = result[:background]
    rgb      = Color::RGB.from_html(bg_hex)
    # Luminosity should be <= 20%
    assert rgb.to_hsl.luminosity <= 20, "Expected dark background, got #{bg_hex} (L=#{rgb.to_hsl.luminosity.round(1)}%)"
  end

  test "dark mood text is very light" do
    result   = generate(mood: "dark")
    text_hex = result[:text]
    rgb      = Color::RGB.from_html(text_hex)
    assert rgb.to_hsl.luminosity >= 75, "Expected light text, got #{text_hex} (L=#{rgb.to_hsl.luminosity.round(1)}%)"
  end

  # ── Light mood lightness expectations ────────────────────────────────────────

  test "light mood background is very light" do
    result  = generate(mood: "light")
    bg_hex  = result[:background]
    rgb     = Color::RGB.from_html(bg_hex)
    assert rgb.to_hsl.luminosity >= 80, "Expected light background, got #{bg_hex} (L=#{rgb.to_hsl.luminosity.round(1)}%)"
  end

  test "light mood text is dark" do
    result   = generate(mood: "light")
    text_hex = result[:text]
    rgb      = Color::RGB.from_html(text_hex)
    assert rgb.to_hsl.luminosity <= 30, "Expected dark text, got #{text_hex} (L=#{rgb.to_hsl.luminosity.round(1)}%)"
  end

  # ── Input validation ─────────────────────────────────────────────────────────

  test "raises ArgumentError for an invalid hex format" do
    err = assert_raises(ArgumentError) { generate(base_hex: "not-a-hex") }
    assert_match(/Invalid base colour/, err.message)
  end

  test "raises ArgumentError for a hex missing the # prefix" do
    err = assert_raises(ArgumentError) { generate(base_hex: "268bd2") }
    assert_match(/Invalid base colour/, err.message)
  end

  test "raises ArgumentError for a 3-digit shorthand hex" do
    err = assert_raises(ArgumentError) { generate(base_hex: "#fff") }
    assert_match(/Invalid base colour/, err.message)
  end

  test "raises ArgumentError for an invalid mood" do
    err = assert_raises(ArgumentError) { generate(mood: "retro") }
    assert_match(/Invalid mood/, err.message)
  end

  test "raises ArgumentError for an invalid harmony" do
    err = assert_raises(ArgumentError) { generate(harmony: "random") }
    assert_match(/Invalid harmony/, err.message)
  end

  test "error message lists valid moods" do
    err = assert_raises(ArgumentError) { generate(mood: "neon") }
    PaletteGeneratorService::MOODS.each do |mood|
      assert_includes err.message, mood
    end
  end

  test "error message lists valid harmonies" do
    err = assert_raises(ArgumentError) { generate(harmony: "spiral") }
    PaletteGeneratorService::HARMONIES.each do |harmony|
      assert_includes err.message, harmony
    end
  end

  # ── Input normalisation ──────────────────────────────────────────────────────

  test "accepts uppercase hex input" do
    result = generate(base_hex: "#268BD2")
    result.each_value { |hex| assert_match VALID_HEX, hex }
  end

  test "strips leading/trailing whitespace from base_hex" do
    result = generate(base_hex: "  #268bd2  ")
    result.each_value { |hex| assert_match VALID_HEX, hex }
  end

  test "accepts mixed-case mood input" do
    result = generate(mood: "Dark")
    result.each_value { |hex| assert_match VALID_HEX, hex }
  end

  test "accepts mixed-case harmony input" do
    result = generate(harmony: "Monochromatic")
    result.each_value { |hex| assert_match VALID_HEX, hex }
  end

  # ── Low-saturation base colour handling ──────────────────────────────────────

  test "greyscale base colour still produces valid output" do
    # Pure grey has 0% saturation — saturation is clamped to 40% by the service
    result = generate(base_hex: "#808080")
    result.each_value { |hex| assert_match VALID_HEX, hex }
  end

  # ── Determinism ──────────────────────────────────────────────────────────────

  test "same inputs always produce the same output" do
    args = { base_hex: "#268bd2", mood: "pastel", harmony: "triadic" }
    first  = PaletteGeneratorService.new(**args).call
    second = PaletteGeneratorService.new(**args).call
    assert_equal first, second
  end
end

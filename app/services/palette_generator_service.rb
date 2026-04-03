class PaletteGeneratorService
  MOODS = %w[dark light pastel vibrant].freeze
  HARMONIES = %w[monochromatic complementary analogous triadic].freeze

  HEX_FORMAT = /\A#[0-9A-Fa-f]{6}\z/

  # Lightness bands per mood: [background_l, surface_l, text_l] as 0..100 floats
  MOOD_LIGHTNESS = {
    "dark"     => { bg: 8.0,  surface: 13.0, text: 88.0 },
    "light"    => { bg: 96.0, surface: 90.0, text: 18.0 },
    "pastel"   => { bg: 94.0, surface: 87.0, text: 22.0 },
    "vibrant"  => { bg: 12.0, surface: 18.0, text: 90.0 }
  }.freeze

  def initialize(base_hex:, mood:, harmony:)
    @base_hex = base_hex.to_s.strip
    @mood     = mood.to_s.downcase
    @harmony  = harmony.to_s.downcase
  end

  def call
    validate!
    generate
  end

  private

  def validate!
    raise ArgumentError, "Invalid base colour — must be a 6-digit hex (e.g. #1a2b3c)" unless @base_hex.match?(HEX_FORMAT)
    raise ArgumentError, "Invalid mood — must be one of: #{MOODS.join(', ')}"           unless MOODS.include?(@mood)
    raise ArgumentError, "Invalid harmony — must be one of: #{HARMONIES.join(', ')}"    unless HARMONIES.include?(@harmony)
  end

  def generate
    base_hsl = hex_to_hsl(@base_hex)
    hue      = base_hsl[:h]
    sat      = base_hsl[:s].clamp(40.0, 100.0)
    bands    = MOOD_LIGHTNESS[@mood]

    hues = hue_set(hue)

    {
      primary:    hsl_to_hex(hues[0], sat,            primary_lightness),
      secondary:  hsl_to_hex(hues[1], (sat * 0.7),    secondary_lightness),
      accent:     hsl_to_hex(hues[2], sat,            accent_lightness),
      background: hsl_to_hex(hue,    [ sat * 0.08, 12 ].min, bands[:bg]),
      surface:    hsl_to_hex(hue,    [ sat * 0.10, 15 ].min, bands[:surface]),
      text:       hsl_to_hex(hue,    [ sat * 0.06, 8 ].min,  bands[:text])
    }.transform_values { |v| v }
  end

  # Returns array of [primary_hue, secondary_hue, accent_hue]
  def hue_set(hue)
    case @harmony
    when "monochromatic"
      [ hue, hue, hue ]
    when "complementary"
      complement = (hue + 180) % 360
      [ hue, complement, hue ]
    when "analogous"
      [ hue, (hue + 30) % 360, (hue - 30 + 360) % 360 ]
    when "triadic"
      [ hue, (hue + 120) % 360, (hue + 240) % 360 ]
    end
  end

  # Lightness for vibrant accent colours — pushed toward mid-range so they're visible on both dark/light
  def primary_lightness
    case @mood
    when "dark"    then 62.0
    when "light"   then 42.0
    when "pastel"  then 68.0
    when "vibrant" then 58.0
    end
  end

  def secondary_lightness
    case @mood
    when "dark"    then 45.0
    when "light"   then 55.0
    when "pastel"  then 72.0
    when "vibrant" then 48.0
    end
  end

  def accent_lightness
    case @mood
    when "dark"    then 70.0
    when "light"   then 38.0
    when "pastel"  then 74.0
    when "vibrant" then 65.0
    end
  end

  # ── Colour conversion helpers ──────────────────────────────────────────────

  def hex_to_hsl(hex)
    rgb = Color::RGB.from_html(hex)
    hsl = rgb.to_hsl
    # .hue => degrees (0..360), .saturation/.luminosity => percent (0..100)
    { h: hsl.hue, s: hsl.saturation, l: hsl.luminosity }
  end

  def hsl_to_hex(h, s, l)
    # Color::HSL.new expects all values as fractions (0..1)
    Color::HSL.new(h / 360.0, s / 100.0, l / 100.0).to_rgb.html
  end
end

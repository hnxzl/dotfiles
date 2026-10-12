hl.config({
    decoration = {
        active_opacity = 0.85,
        inactive_opacity = 0.55,
    },
})

if hl.plugin.hyprglass then
    local hg = hl.plugin.hyprglass

    hg.preset("apple", {
        blur_strength = 2.2,
        blur_iterations = 3,
        refraction_strength = 0.55,
        chromatic_aberration = 0.3,
        fresnel_strength = 0.5,
        specular_strength = 0.75,
        edge_thickness = 0.05,
        lens_distortion = 0.3,
        dark  = { brightness = 0.82, contrast = 0.90, saturation = 0.80, vibrancy = 0.13, adaptive_dim = 0.4 },
        light = { brightness = 1.12, contrast = 0.92, saturation = 0.85, vibrancy = 0.12, adaptive_boost = 0.4 },
    })

    hg.layer("waybar", { preset = "apple" })
    hg.layer("rofi", { preset = "apple" })

    hg.config({
        enabled = true,
        default_theme = "dark",
        default_preset = "apple",
        layers = { enabled = true },
    })

hl.window_rule({
        match = { class = "zen", title = ".*YouTube.*" },
        tag = "+hyprglass_disabled",
    })
end


using Cairo, Colors

# Configuration
const N = 12
const WIDTH = 1000
const HEIGHT = 1000
const COMMON_POINT = (500.0, 500.0)

# 1. Data Structure to keep PDF and PNG identical
struct CircleData
    center::Tuple{Float64, Float64}
    radius::Float64
    color::RGBA
end

function generate_random_data(n)
    data = CircleData[]
    for _ in 1:n
        # Random center within a reasonable range
        cx, cy = rand(250.0:750.0), rand(250.0:750.0)
        
        # Ensure circle contains COMMON_POINT: radius must be > distance to point
        dist_to_common = sqrt((cx - COMMON_POINT[1])^2 + (cy - COMMON_POINT[2])^2)
        radius = dist_to_common + rand(40.0:150.0) # Ensure it's never "too small"
        
        # Create a bright, visible color (HSVA for better control)
        # We store it as RGBA to easily manipulate alpha later
        c = HSVA(rand() * 360, 0.8, 0.9, 1.0) 
        push!(data, CircleData((cx, cy), radius, RGBA(c)))
    end
    return data
end

"""
Draws the circles to a specific context.
"""
function draw_circles_to_ctx(cr, data)
    # Background
    set_source_rgb(cr, 1, 1, 1)
    paint(cr)

    for c in data
        # Define the path
        arc(cr, c.center..., c.radius, 0, 2π)
        
        # 1. Fill the interior (Transparent)
        set_source_rgba(cr, red(c.color), green(c.color), blue(c.color), 0.25)
        fill_preserve(cr) # Keeps the circle path for the stroke
        
        # 2. Draw the boundary (Opaque)
        set_source_rgba(cr, red(c.color), green(c.color), blue(c.color), 1.0)
        set_line_width(cr, 6.0) # Thicker boundary
        stroke(cr)
    end

    # Show the common point
    set_source_rgb(cr, 0, 0, 0)
    arc(cr, COMMON_POINT..., 16, 0, 2π)
    fill(cr)
end

"""
Draws the n-gon and diagonals to a specific context.
"""
function draw_ngon_to_ctx(cr, data)
    set_source_rgb(cr, 1, 1, 1)
    paint(cr)

    center = (WIDTH/2, HEIGHT/2)
    radius = 400.0
    vertices = [(center[1] + radius * cos(2π * i / N), center[2] + radius * sin(2π * i / N)) for i in 0:N-1]

    # Draw all diagonals first (thin lines)
    set_line_width(cr, 2)
    set_source_rgba(cr, 0.1, 0.1, 0.1, 0.7)
    for i in 1:N, j in i+1:N
        move_to(cr, vertices[i]...)
        line_to(cr, vertices[j]...)
        stroke(cr)
    end

    # Draw vertices with the same colors as the circles
    for i in 1:N
        c = data[i].color
        set_source_rgba(cr, red(c), green(c), blue(c), 1.0)
        arc(cr, vertices[i]..., 12, 0, 2π)
        fill(cr)
    end
end

# --- Main Logic ---

# Generate data once
circle_list = generate_random_data(N)

# Output Circles
# PDF
pdf_circles = CairoPDFSurface("circles.pdf", WIDTH, HEIGHT)
draw_circles_to_ctx(CairoContext(pdf_circles), circle_list)
finish(pdf_circles)

# PNG
png_circles = CairoImageSurface(WIDTH, HEIGHT, Cairo.FORMAT_ARGB32)
draw_circles_to_ctx(CairoContext(png_circles), circle_list)
write_to_png(png_circles, "circles.png")
finish(png_circles)

# Output N-gon
# PDF
pdf_ngon = CairoPDFSurface("ngon.pdf", WIDTH, HEIGHT)
draw_ngon_to_ctx(CairoContext(pdf_ngon), circle_list)
finish(pdf_ngon)

# PNG
png_ngon = CairoImageSurface(WIDTH, HEIGHT, Cairo.FORMAT_ARGB32)
draw_ngon_to_ctx(CairoContext(png_ngon), circle_list)
write_to_png(png_ngon, "ngon.png")
finish(png_ngon)

println("Success: Circles and N-gon generated in PDF and PNG formats.")

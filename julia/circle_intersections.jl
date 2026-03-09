using Cairo, Colors

# Configuration
const N = 20
const WIDTH = 1000
const HEIGHT = 1000
const OUTPUT_DIR = "output"

# Ensure output directory exists
mkpath(OUTPUT_DIR)

struct CircleData
    center::Tuple{Float64, Float64}
    radius::Float64
    color::RGBA
end

function generate_random_data(n)
    data = CircleData[]
    for _ in 1:n
        # Random center anywhere on canvas
        cx, cy = rand(100.0:900.0), rand(100.0:900.0)
        
        # Random sizes (smaller range as requested)
        radius = rand(50.0:180.0)
        
        # Bright HSVA color
        c = HSVA(rand() * 360, 0.8, 0.9, 1.0) 
        push!(data, CircleData((cx, cy), radius, RGBA(c)))
    end
    return data
end

"""
Draws the circles. Interior is transparent, boundary is opaque and thick.
"""
function draw_circles_to_ctx(cr, data)
    set_source_rgb(cr, 1, 1, 1) # White background
    paint(cr)

    for c in data
        arc(cr, c.center..., c.radius, 0, 2π)
        
        # Interior (Transparent)
        set_source_rgba(cr, red(c.color), green(c.color), blue(c.color), 0.3)
        fill_preserve(cr)
        
        # Boundary (Opaque)
        set_source_rgba(cr, red(c.color), green(c.color), blue(c.color), 1.0)
        set_line_width(cr, 4.0)
        stroke(cr)
    end
end

"""
Draws the n-gon. Edges exist ONLY if the corresponding circles intersect.
"""
function draw_graph_to_ctx(cr, data)
    set_source_rgb(cr, 1, 1, 1)
    paint(cr)

    center = (WIDTH/2, HEIGHT/2)
    poly_radius = 400.0
    vertices = [(center[1] + poly_radius * cos(2π * i / N), 
                 center[2] + poly_radius * sin(2π * i / N)) for i in 0:N-1]

    # Draw edges based on circle intersection
    set_line_width(cr, 2.5)
    for i in 1:N, j in i+1:N
        c1, c2 = data[i], data[j]
        # Calculate Euclidean distance between circle centers
        dist = sqrt((c1.center[1] - c2.center[1])^2 + (c1.center[2] - c2.center[2])^2)
        
        # Edge condition: distance <= sum of radii
        if dist <= (c1.radius + c2.radius)
            set_source_rgba(cr, 0.2, 0.2, 0.2, 0.6) # Dark grey edge
            move_to(cr, vertices[i]...)
            line_to(cr, vertices[j]...)
            stroke(cr)
        end
    end

    # Draw vertices
    for i in 1:N
        c = data[i].color
        set_source_rgba(cr, red(c), green(c), blue(c), 1.0)
        arc(cr, vertices[i]..., 12, 0, 2π)
        fill(cr)
    end
end

# --- Execution ---

# 1. Generate consistent data
circle_list = generate_random_data(N)

# 2. Render Circles
# PDF
surf_c_pdf = CairoPDFSurface(joinpath(OUTPUT_DIR, "circles.pdf"), WIDTH, HEIGHT)
draw_circles_to_ctx(CairoContext(surf_c_pdf), circle_list)
finish(surf_c_pdf)

# PNG
surf_c_png = CairoImageSurface(WIDTH, HEIGHT, Cairo.FORMAT_ARGB32)
draw_circles_to_ctx(CairoContext(surf_c_png), circle_list)
write_to_png(surf_c_png, joinpath(OUTPUT_DIR, "circles.png"))
finish(surf_c_png)

# 3. Render Intersection Graph (N-gon)
# PDF
surf_g_pdf = CairoPDFSurface(joinpath(OUTPUT_DIR, "intersection_graph.pdf"), WIDTH, HEIGHT)
draw_graph_to_ctx(CairoContext(surf_g_pdf), circle_list)
finish(surf_g_pdf)

# PNG
surf_g_png = CairoImageSurface(WIDTH, HEIGHT, Cairo.FORMAT_ARGB32)
draw_graph_to_ctx(CairoContext(surf_g_png), circle_list)
write_to_png(surf_g_png, joinpath(OUTPUT_DIR, "intersection_graph.png"))
finish(surf_g_png)

println("Files saved to the /$(OUTPUT_DIR) folder.")

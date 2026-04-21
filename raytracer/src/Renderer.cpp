#include "Renderer.h"

Renderer::Renderer(Film* film, Camera* camera, const std::vector<Shape*>& shapes) 
: _film(film), _camera(camera), _shapes(shapes) {
}

void Renderer::Render() {
    for (std::size_t y = 0; y < _film->GetTamY(); ++y) {
        for (std::size_t x = 0; x < _film->GetTamX(); ++x) {
            const Ray ray_primary = _camera->get_ray(x, y);
            const Color c = ray_color(ray_primary);
            _film->AddPixel(c);
        }
    }
}

Color Renderer::ray_color(const Ray& r) {
    for (Shape* s : _shapes) {
        if (s->Intersect(r, 0, 0))
            return *s->getMaterial()->getBaseColor();
    }

    glm::vec3 unit_direction = glm::normalize(r.direction());
    float a = 0.5 * (unit_direction.y + 1.0);
    return (1.0f - a) * Color(1.0, 1.0, 1.0) + a * Color(0.5, 0.7, 1.0);
}

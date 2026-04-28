#include "Renderer.h"

Renderer::Renderer(Film* film, Camera* camera, World* world)
	: _film(film), _camera(camera), _world(world) {
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

Color Renderer::ray_color(const Ray& r) const {
	ShapeIntersection intersection;
	if (_world->getShapeScene()->Intersect(r, 0, 50, intersection)) {
		return shade(r, intersection);
	}

	return BLACK;

	/*glm::vec3 unit_direction = glm::normalize(r.direction());
	float a = 0.5 * (unit_direction.y + 1.0);
	return (1.0f - a) * Color(1.0, 1.0, 1.0) + a * Color(0.5, 0.7, 1.0);*/
}

Color Renderer::shade(Ray r, ShapeIntersection hit) const {
	Color ret(BLACK);
	// Ambiente
	ret += Color(0.1, 0.1, 0.1); // Luz de ambiente , cableada

	// luces
	for (std::shared_ptr<Light> l : _world->getLightVector()) {
		if (l->projectShadows()) {
			Ray shadowRay(hit.getPoint(), l->shadowDir(hit.getPoint()));
			ShapeIntersection si;
			if (_world->getShapeScene()->Intersect(shadowRay, 0, 50, si)){
				continue;
			}
			ret += l->shade(r, hit);
		}
	}

	// reflejo
	if (hit.getMaterial()->getReflexFactor() > 0.0f) {
		Ray secondaryRay(hit.getPoint(), glm::reflect(hit.getPoint(), hit.getNormal()));
		ret += hit.getMaterial()->getReflexFactor() * ray_color(secondaryRay);
	}

	return ret;
}

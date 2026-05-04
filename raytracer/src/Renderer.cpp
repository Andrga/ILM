#include "Renderer.h"

Renderer::Renderer(Film* film, Camera* camera, World* world)
	: _film(film), _camera(camera), _world(world) {
}

void Renderer::Render(float numSamples) {
	for (std::size_t y = 0; y < _film->GetTamY(); ++y) {
		for (std::size_t x = 0; x < _film->GetTamX(); ++x) {
			Color pixelColor = BLACK;
			for (std::size_t z = 0; z < numSamples; ++z) {
				const Ray ray_primary = _camera->get_ray(x, y);
				pixelColor += ray_color(ray_primary);
			}
			_film->AddPixel(pixelColor/numSamples);
		}
	}
}

Color Renderer::ray_color(const Ray& r, int i) const {
	ShapeIntersection intersection;
	if (_world->getShapeScene()->Intersect(r, 0.001f, 50, intersection)) {
		return shade(r, intersection, i);
	}

	return BLACK;
}

Color Renderer::shade(Ray r, ShapeIntersection hit, int i) const {
	Color ret(BLACK);
	// Ambiente - Mas bonito en negro puro :-]
	//ret += Color(0.1, 0.1, 0.1); // Luz de ambiente , cableada
	
	// luces
	for (std::shared_ptr<Light> l : _world->getLightVector()) {
		if (l->projectShadows()) {
			Ray shadowRay(hit.getPoint(), l->shadowDir(hit.getPoint()));
			ShapeIntersection si;
			if (_world->getShapeScene()->Intersect(shadowRay, 0.001f, 50, si)){
				continue;
			}
			ret += l->shade(r, hit);
		}
	}

	// reflejo
	if (i < _reflexDeepness && hit.getMaterial() && hit.getMaterial()->getReflexFactor() > 0.0f) {
		Ray secondaryRay(hit.getPoint(), glm::reflect(glm::normalize(r.direction()), hit.getNormal()));
		ret += hit.getMaterial()->getReflexFactor() * ray_color(secondaryRay, i++);
	}

	return ret;
}

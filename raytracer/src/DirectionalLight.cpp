#include "DirectionalLight.h"
#include <algorithm>
#include <cmath>
#include <glm/geometric.hpp>

DirectionalLight::DirectionalLight(const glm::vec3& dir, const Color& color) : _direction(dir), _color(color) {
}

Color DirectionalLight::shade(Ray r, ShapeIntersection hit) {
	// Diffuse
	float intensity = std::max(0.0f, glm::dot(hit.getNormal(), _direction));
	glm::vec3 diffuse = _color * intensity;
	// Especular
	glm::vec3 view = r.direction();
	glm::vec3 halfVector = glm::normalize(_direction + view);

	float specular = std::max(0.0f, glm::dot(hit.getNormal(), halfVector));
	specular = std::pow(specular, _glossPower);

	return Color(hit.getMaterial()->getBaseColor() * diffuse + Color(specular));
}

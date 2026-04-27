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
	glm::vec3 view = glm::normalize(- r.direction());
	glm::vec3 radius = 2 * glm::dot(hit.getNormal(), _direction) * hit.getNormal() - _direction;

	float specular = std::max(0.0f, glm::dot(view, radius));
	specular = std::pow(specular, _glossPower);
	glm::vec3 specularColor = _color * specular;

	return Color(hit.getMaterial()->getBaseColor() * diffuse + specularColor);
}

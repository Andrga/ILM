#include "DirectionalLight.h"
#include <algorithm>
#include <cmath>
#include <glm/geometric.hpp>

DirectionalLight::DirectionalLight(const glm::vec3& dir, const Color& color, float glossPower, bool projectShadows)
	: Light(color, glossPower, projectShadows), _direction(glm::normalize(dir)) {
}
Color DirectionalLight::shade(Ray r, ShapeIntersection hit) {
	// Diffuse
	float intensity = std::max(0.0f, glm::dot(hit.getNormal(), _direction));
	glm::vec3 diffuse = _color * intensity;
	// Especular
	glm::vec3 viewDir = glm::normalize(-r.direction());
	glm::vec3 lightDir = glm::normalize(_direction);
	glm::vec3 halfVector = glm::normalize(lightDir + viewDir);

	float specularIntensity = std::max(0.0f, glm::dot(hit.getNormal(), halfVector));
	specularIntensity = std::pow(specularIntensity, _glossPower);
	glm::vec3 specular = _color * specularIntensity;

	return Color(hit.getMaterial()->getBaseColor(hit.getUVS().x, hit.getUVS().y) * diffuse + specular);
}

glm::vec3 DirectionalLight::shadowDir(glm::vec3 point)
{
	return _direction;
}

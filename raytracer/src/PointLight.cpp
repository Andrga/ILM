#include "PointLight.h"

#include <cmath>
#include <glm/geometric.hpp>

PointLight::PointLight(const glm::vec3& point, const Color& color, float glossPower, bool projectShadows):
	Light(color, glossPower, projectShadows), _point(point)
{}

Color PointLight::shade(Ray r, const ShapeIntersection& hit)
{
	// Diffuse
	glm::vec3 direction = glm::normalize( _point - hit.getPoint());
	float intensity = std::max(0.0f, glm::dot(hit.getNormal(), direction));
	glm::vec3 diffuse = _color * intensity;
	// Especular
	glm::vec3 viewDir = glm::normalize(-r.direction());
	glm::vec3 lightDir = glm::normalize(direction);
	glm::vec3 halfVector = glm::normalize(lightDir + viewDir);

	float specularIntensity = std::max(0.0f, glm::dot(hit.getNormal(), halfVector));
	specularIntensity = std::pow(specularIntensity, _glossPower);
	glm::vec3 specular = _color * specularIntensity;

	return Color(hit.getMaterial()->getBaseColor(hit.getUVS().x, hit.getUVS().y) * diffuse + specular);
}

glm::vec3 PointLight::shadowDir(glm::vec3 point)
{
	return  glm::normalize(_point - point);
}

#include "Quad.h"

#include <glm/geometric.hpp>

Quad::Quad(glm::vec3 Q, glm::vec3 u, glm::vec3 v, std::shared_ptr<Material> mat) :
	Shape(mat), _Q(Q), _u(u), _v(v)
{
	glm::vec3 n = cross(u, v);
	_normal = glm::normalize(n);
	_D = dot(_normal, _Q);
	//_w = n / glm::dot(glm::normalize(_u), glm::normalize(_v));
	_w = n / glm::dot(n, n);
}

bool Quad::Intersect(const Ray& ray, float tMin, float tMax) const
{
	float denom = glm::dot(_normal, glm::normalize(ray.direction()));

	// No intersecciona si es paralelo al plano
	if (std::fabs(denom) < 1e-8)
		return false;

	// No intersecciona si no esta en el umbral de t
	float t = (_D - glm::dot(_normal, ray.origin())) / denom;
	if (t<tMin || t>tMax)
		return false;

	return true;
}

bool Quad::Intersect(const Ray& ray, float tMin, float tMax, ShapeIntersection& shapeIntersection) const
{
	float denom = glm::dot(_normal, ray.direction());

	// No intersecciona si es paralelo al plano
	if (std::fabs(denom) < 1e-8)
		return false;

	// No intersecciona si no esta en el umbral de t
	float t = (_D - glm::dot(_normal, ray.origin())) / denom;
	if (t<tMin || t>tMax)
		return false;

	glm::vec3 p = ray.origin() + t * ray.direction();
	glm::vec3 pq = p - _Q;

	float a = glm::dot(_w, glm::cross(_v, pq));
	float b = glm::dot(_w, glm::cross(pq, _u));

	if (a < 0.0f || a > 1.0f || b < 0.0f || b > 1.0f)
		return false;

	// Construye la interseccion
	shapeIntersection = ShapeIntersection(_material, p, _normal);
	return true;
}

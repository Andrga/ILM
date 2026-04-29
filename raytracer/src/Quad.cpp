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

	glm::vec3 p = ray.origin() + t * glm::normalize(ray.direction());

	glm::vec3 planar_hitpt_vector = p - _Q;
	float alpha = dot(_w, cross(planar_hitpt_vector, _v));
	float beta = dot(_w, cross(_u, planar_hitpt_vector));


	// Construye la interseccion
	shapeIntersection = ShapeIntersection(_material, p, _normal);
	if (!isInterior(alpha, beta))
		return false;
	return true;
}

bool Quad::isInterior(float a, float b) const
{
	return !((a < 0 || a > 1) || (b < 0 || b > 1));
}

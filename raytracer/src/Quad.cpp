#include "Quad.h"

#include <glm/geometric.hpp>

Quad::Quad(glm::vec3 Q, glm::vec3 u, glm::vec3 v, std::shared_ptr<Material> mat) :
	Shape(mat), _Q(Q), _u(u), _v(v)
{
	glm::vec3 n = cross(u, v);
	_normal = glm::normalize(n);
	_D = dot(_normal, _Q);
	_w = n / glm::dot(n, n);
}

void Quad::getUVS(const glm::vec3& p, float& u, float& v) const { 
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

	auto intersection = ray.at(t);
	glm::vec3 planar_hitpt_vector = intersection - _Q;

	auto a = glm::dot(_w, cross(planar_hitpt_vector, _v));
	auto b = glm::dot(_w, cross(_u, planar_hitpt_vector));


	if (a < 0.0f || a > 1.0f || b < 0.0f || b > 1.0f)
		return false;

	// Construye la interseccion
	shapeIntersection._material = _material;
	shapeIntersection._point = intersection;
	shapeIntersection._normal = _normal;
	shapeIntersection._u = a;
	shapeIntersection._v = b;

	return true;
}

#define _USE_MATH_DEFINES
#include "Sphere.h"
#include <cmath>

Sphere::Sphere(glm::vec3 center, float radius, std::shared_ptr<Material> mat) : Shape(mat), _center(center), _radius(radius) {
}

void Sphere::getUVS(const glm::vec3& p, float& u, float& v) const {
	// p: a given point on the sphere of radius one, centered at the origin.
	// u: returned value [0,1] of angle around the Y axis from X=-1.
	// v: returned value [0,1] of angle from Y=-1 to Y=+1.

	auto theta = std::acos(-p.y);
	auto phi = std::atan2(-p.z, p.x) + M_PI;

	u = phi / (2 * M_PI);
	v = theta / M_PI;
}

bool Sphere::Intersect(const Ray& ray, float tMin, float tMax) const {
	glm::vec3 oc = _center - ray.origin();
	auto a = glm::dot(ray.direction(), ray.direction());
	auto b = -2.0 * glm::dot(ray.direction(), oc);
	auto c = glm::dot(oc, oc) - _radius * _radius;
	auto discriminant = b * b - 4 * a * c;
	return (discriminant >= 0);
}

bool Sphere::Intersect(const Ray& ray, float tMin, float tMax, ShapeIntersection& shapeIntersection) const
{
	glm::vec3 oc = _center - ray.origin();
	auto a = glm::dot(glm::normalize(ray.direction()), glm::normalize(ray.direction()));
	auto b = -2.0 * glm::dot(ray.direction(), oc);
	auto c = glm::dot(oc, oc) - _radius * _radius;
	auto discriminant = b * b - 4 * a * c;
	if (discriminant >= 0)
	{
		float t = (-b - std::sqrt(discriminant)) / (2.0 * a);
		if (t > tMin && t < tMax) {
			glm::vec3 p = ray.origin() + t * ray.direction();
			float u; float v;
			getUVS(p, u, v);
			shapeIntersection = ShapeIntersection(_material, p, glm::normalize(p - _center), u, v);
			return true;
		}
	}
	return false;
}

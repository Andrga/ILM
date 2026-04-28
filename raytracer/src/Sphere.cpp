#include "Sphere.h"

Sphere::Sphere(glm::vec3 center, float radius, std::shared_ptr<Material> mat) : Shape(mat), _center(center), _radius(radius) {
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
	auto a = glm::dot(ray.direction(), ray.direction());
	auto b = -2.0 * glm::dot(ray.direction(), oc);
	auto c = glm::dot(oc, oc) - _radius * _radius;
	auto discriminant = b * b - 4 * a * c;
	if (discriminant >= 0)
	{
		float t = (-b - std::sqrt(discriminant)) / (2.0 * a);
		if (t > tMin && t < tMax) {
			glm::vec3 p = ray.origin() + t * ray.direction();
			shapeIntersection = ShapeIntersection(_material, p, glm::normalize(p - _center));
			return true;
		}
	}
	return false;
}

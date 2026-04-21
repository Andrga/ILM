#include "Sphere.h"

Sphere::Sphere(glm::vec3 center, float radius, Material* mat) : Shape(mat), _center(center), _radius(radius){

}

bool Sphere::Intersect(const Ray& ray, float tMin, float tMax) const {
    glm::vec3 oc = _center - ray.origin();
    auto a = glm::dot(ray.direction(), ray.direction());
    auto b = -2.0 * glm::dot(ray.direction(), oc);
    auto c = glm::dot(oc, oc) - _radius * _radius;
    auto discriminant = b * b - 4 * a * c;
    return (discriminant >= 0);
}

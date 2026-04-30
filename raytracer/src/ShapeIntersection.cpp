#include "ShapeIntersection.h"
#include <glm/geometric.hpp>

ShapeIntersection::ShapeIntersection(std::shared_ptr<Material> const& material, glm::vec3 point, glm::vec3 normal, float u, float v)
	: _material(material), _point(point), _normal(normal), _u(u), _v(v) {}

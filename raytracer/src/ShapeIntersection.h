#pragma once
#include <memory>
#include "Material.h"

class ShapeIntersection
{
public:
	ShapeIntersection() : _material(nullptr), _point({0,0,0}) {}
	ShapeIntersection(std::shared_ptr<Material> const& material, glm::vec3 point) : _material(material), _point(point) {}
	std::shared_ptr<Material> getMaterial() const { return _material; }
	glm::vec3 getPoint() const { return _point; }
private:
	std::shared_ptr<Material> _material;
	glm::vec3 _point;
};


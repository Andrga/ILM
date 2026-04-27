#pragma once
#include <memory>
#include "Material.h";

class ShapeIntersection
{
public:
	ShapeIntersection() : ShapeIntersection(nullptr, { 0,0,0 }, { 0,0,0 }) {}
	ShapeIntersection(std::shared_ptr<Material> const& material, glm::vec3 point, glm::vec3 normal);
	std::shared_ptr<Material> getMaterial() const { return _material; }
	glm::vec3 getPoint() const { return _point; }
	glm::vec3 getNormal() const { return _normal; }
private:
	std::shared_ptr<Material> _material;
	glm::vec3 _point;
	glm::vec3 _normal;
};


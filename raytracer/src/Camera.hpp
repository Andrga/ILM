#ifndef CAMERA_HPP
#define CAMERA_HPP

#include "glm/vec3.hpp"
#include "Film.h"
#include "Ray.hpp"

struct Camera {

	Camera(
		const Film& film,
		glm::vec3 position,
		glm::vec3 look,
		glm::vec3 up,
		const float fov_degrees_vertical,
		float ba
	);

	Ray get_ray(int x, int y) const;
	glm::vec3 randomPointInCircle(float radius) const;

	float blurAngle = 0;  // Variation angle of rays through each pixel
	float focalLength = 1000;    // Distance from camera lookfrom point to plane of perfect focus

private:
	glm::vec3 position;
	glm::vec3 delta_x;
	glm::vec3 delta_y;
	glm::vec3 position_top_left;

	glm::vec3 blurU;
	glm::vec3 blurV;
};

#endif

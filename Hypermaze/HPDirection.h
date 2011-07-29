#define DIR_TOTAL_DIRECTIONS 6

typedef enum {
	dirNorth = 1,
	dirNorthWest = 2,
	dirNorthEast = 4,
	dirSouthWest = 8,
	dirSouthEast = 16,
	dirSouth = 32
} HPDirection;
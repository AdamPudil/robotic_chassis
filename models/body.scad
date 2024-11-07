

body_width = 100;
body_length = 90;
body_height = 20;

module mirror_copy(vec) {
        mirror(vec) {
            children();
        }
        children();
}


module body() {
    width = body_width;
    length = body_length;
    height = body_height;

    difference() {
        union() {
            cube([width, length, height], center = true);
        }
            
        
    }
}

body();
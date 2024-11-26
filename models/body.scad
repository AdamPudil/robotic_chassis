

body_width = 100;
body_length = 90;
body_height = 25;

small_screw_d_thread = 2;
small_screw_d_pass = 3.2;
small_screw_length = 13;
small_screw_head_length = 3;
small_screw_head_d = 6;

motor_d = 12;
motor_height = 10;
motor_length = 19;
motor_back_offset = 20;
motor_holder_width = 32;
cabel_channel_width = 6;

battery_box_width = 64;
battery_box_length = 59;
battery_box_depth = 2;
battery_box_back_offset = 10;

eletronic_cutout_width = 36;
eletronic_cutout_length = 59;
eletronic_cutout_depth = 22;

ball_wheel_width = 51;
ball_wheel_length = 25;
ball_wheel_depth = 9;
ball_wheel_front_offset = 10;
ball_wheel_screw_distance = 40;

module mirror_copy(vec) {
        mirror(vec) {
            children();
        }
        children();
}

module small_screw_pass_cutout() {
    cylinder(d = small_screw_d_pass, h = small_screw_length, center = true);
    translate([0,0, (small_screw_length + small_screw_head_length) / 2])
        cylinder(d = small_screw_head_d, h = small_screw_head_length, center = true);
}

module small_screw_thread_cutout() {
    cylinder(d = small_screw_d_thread, h = small_screw_length, center = true);
}


module body() {
    width = body_width;
    length = body_length;
    height = body_height;

    module motor_cutouts() {
        rotate([0, 90, 0]) {
            // cable shaft
            channel_length = body_width / 2 - motor_length;
            translate([0, 0, (- channel_length - motor_length) / 2 ])
            cube([cabel_channel_width, cabel_channel_width, channel_length], center = true);
            
            difference() {
                cylinder(d = motor_d, h = motor_length, center = true);
                
                mirror_copy([1,0,0]) {
                    translate([(motor_height + 2) / 2, 0, 0])
                    cube([2, motor_d, motor_length], center = true);
                }
            }
        }
        
        mirror_copy([0,1,0])
        translate([0, motor_holder_width / 2 - 5, small_screw_length / 2]) {
            small_screw_thread_cutout();
        }

        translate([0, 0, -motor_height / 4])
        cube([motor_length, motor_holder_width, motor_height / 2], center = true);
    }
    
    module battery_box_cutout() {
        cube([battery_box_width, battery_box_length, battery_box_depth], center = true);
    }
    
    module ball_wheel_cutout() {
        cube([ball_wheel_width, 
              ball_wheel_length,
              ball_wheel_depth], center = true);

        mirror_copy([1,0,0])
            translate([ball_wheel_screw_distance / 2,0,small_screw_length / 2])
            small_screw_thread_cutout();
    }
    
    module electronic_cutout() {
        cube([eletronic_cutout_width,
              eletronic_cutout_length,
              eletronic_cutout_depth],
             center = true);
    }

    difference() {
        union() {
            cube([width, length, height], center = true);
        }
            
        mirror_copy([1, 0, 0]) {
            translate([(width - motor_length) / 2, length / 2 - motor_back_offset,
            - (height - motor_height) / 2])
            motor_cutouts();
        }
        
        translate([0, (length - battery_box_length) / 2 - battery_box_back_offset, (height - battery_box_depth) / 2])
            battery_box_cutout();
        
        translate([0,
                   (length - eletronic_cutout_length) / 2 - battery_box_back_offset,
                   (height - eletronic_cutout_depth) / 2 - battery_box_depth])
            electronic_cutout();
        
        translate([0,
                  (length - ball_wheel_length) / -2 + ball_wheel_front_offset
                  (height - ball_wheel_depth) / 2
            ])
            ball_wheel_cutout();
    }
}

body();
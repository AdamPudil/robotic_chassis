

body_width = 100;
body_length = 110;
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

cabel_channel_width = 6;

motor_holder_width = 32;
motor_holder_bulge = 16;

ball_wheel_width = 51;
ball_wheel_length = 25;
ball_wheel_depth = 3;
ball_wheel_front_offset = 10;
ball_wheel_screw_distance = 40;
ball_wheel_height = 17;

battery_box_width = 64;
battery_box_length = 59;
battery_box_depth = 2;
battery_box_height = 14;
battery_box_rounding_r = 5;
battery_box_back_offset = 10;
battery_box_cable_width = 12;
battery_box_cable_length = 5;
battery_box_cable_offset = 10;
battery_box_wall_width = 5;

front_width = 36;
front_angle = 30;
front_cutout_depth = tan(front_angle) * (battery_box_width - front_width) / 2;

electronic_cutout_width = 38;
electronic_cutout_length = 59;
electronic_cutout_depth = 22;

i2c_mux_cutout_width = electronic_cutout_width;
i2c_mux_cutout_wall_thick = 5;
i2c_mux_cutout_bottom_wall = 2;
i2c_mux_cutout_front_offset = 3;
i2c_mux_cutout_length = body_length - 2 * i2c_mux_cutout_wall_thick - battery_box_length - battery_box_back_offset - front_cutout_depth + i2c_mux_cutout_front_offset;
i2c_mux_cutout_depth = body_height + battery_box_height - ball_wheel_depth - small_screw_length - i2c_mux_cutout_bottom_wall;
i2c_mux_lid_offset = 3;
i2c_mux_lid_depth = 3; 

i2c_mux_cable_cutout_width = 11;
i2c_mux_cable_cutout_length = 10;

laser_cutout_width = 11;
laser_cutout_length = 15;
laser_cutout_depth = 3;
laser_cutout_offset = 4;
laser_cutout_z_offset = 2;

laser_floor_range = 75;
laser_floor_tan_angle = (ball_wheel_height + laser_cutout_z_offset) / laser_floor_range;
laser_floor_bottom_offset = laser_cutout_length * laser_floor_tan_angle;
laser_floor_front_offset = (laser_floor_bottom_offset + laser_cutout_depth) * laser_floor_tan_angle;

laser_cable_width = 4;
laser_cable_lenght = 15;

gyroscope_width = 16;
gyroscope_length = 27; 
gyroscope_depth = 5;
gyroscope_offset = 10;

button_cutout_length = 15;
button_cutout_width =  9;
button_x_offset = (electronic_cutout_width - button_cutout_width) / 2;
button_y_offset = -(electronic_cutout_length - button_cutout_length) / 2;

tolerance = 0.2;

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

module motor_holder() {
    difference() {
        union() {
            cube([motor_length, motor_holder_width, motor_height / 2], center = true);

            translate([0,0,motor_height / 4])
            rotate([0, 90, 0])
                cylinder(d = motor_holder_bulge, h = motor_length, center = true);
        }

        translate([0,0,motor_height / 4])
        rotate([0, 90, 0]) {           
            difference() {
                cylinder(d = motor_d, h = motor_length, center = true);
                    
                mirror_copy([1,0,0]) {
                    translate([(motor_height + 2) / 2 + tolerance, 0, 0])
                    cube([2, motor_d, motor_length], center = true);
                }
            }
        }

        translate([0,0, motor_height / 4 + motor_height / 2])
            cube([motor_length, motor_holder_width, motor_height], center = true);

        translate([0,0, - motor_holder_bulge / 2 + (motor_d - motor_height) / 2 ])
            cube([motor_length, motor_holder_width, motor_height / 2], center = true);

        mirror_copy([0, 1, 0])
        translate([0, motor_holder_width / 2 - 5, (small_screw_length) / 2 + small_screw_head_length - motor_height / 4 ])
        rotate([0, 180, 0])
            small_screw_pass_cutout();
    }
}

module body() {
    width = body_width;
    length = body_length;
    height = body_height;

    module top_rounding() {
        rotate([90, 0, 0]) {
            difference() {
                translate([battery_box_rounding_r / 2, battery_box_rounding_r / 2, 0])
                    cube([battery_box_rounding_r, battery_box_rounding_r, body_length], center = true);

                cylinder(r = battery_box_rounding_r, h = body_length, center=true);
            }
        }
    }

    module side_cutouts() {
        translate([0, 0, battery_box_height / 2])
        linear_extrude(height + battery_box_height, [0, 0, 1], center = true)
        polygon([
            [body_width / 2, -body_length / 2],
            [front_width / 2, -body_length / 2],
            [battery_box_width / 2, -body_length / 2 + front_cutout_depth], 
            [battery_box_width / 2, body_length / 2 - battery_box_back_offset - battery_box_length - battery_box_wall_width],
            [battery_box_width / 2 + battery_box_wall_width, body_length / 2 - battery_box_back_offset - battery_box_length],
            [battery_box_width / 2 + battery_box_wall_width, body_length / 2 - 2 * motor_back_offset],
            [width / 2, body_length / 2 - 2 * motor_back_offset],
        ]);
    }

    module motor_cutouts() {
        rotate([0, 90, 0]) {
            // cable shaft
            channel_length = body_width / 2 - motor_length;

            translate([0, 0, (- channel_length - motor_length) / 2 ])
                cube([cabel_channel_width, cabel_channel_width, channel_length], center = true);
            
            difference() {
                cylinder(d = motor_d, h = motor_length + 2 * tolerance, center = true);
                
                mirror_copy([1,0,0]) {
                    translate([(motor_height + 2) / 2 + tolerance, 0, 0])
                    cube([2, motor_d, motor_length], center = true);
                }
            }
        }
        
        mirror_copy([0,1,0])
        translate([0, motor_holder_width / 2 - 5, small_screw_length / 2]) {
            small_screw_thread_cutout();
        }

        translate([0, 0, -motor_height / 4])
            cube([motor_length + 2 * tolerance, motor_holder_width + 2 * tolerance, motor_height / 2 + tolerance], center = true);
    }
    
    module battery_box_cutout() {
        translate([0,0, battery_box_height / 2])
            cube([battery_box_width, battery_box_length, battery_box_depth + battery_box_height], center = true);

        translate([- battery_box_width / 2 + battery_box_cable_offset + battery_box_cable_width / 2, - battery_box_length / 2, 0])
            cube([battery_box_cable_width, battery_box_cable_length, electronic_cutout_depth], center = true);
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
        cube([electronic_cutout_width,
              electronic_cutout_length,
              electronic_cutout_depth],
             center = true);

        translate([button_x_offset, button_y_offset, 0])
            cube([button_cutout_width, button_cutout_length, body_height], center = true);
    }

    module gyroscope_cutout() {
        cube([gyroscope_width,
              gyroscope_length, 
              gyroscope_depth], 
             center = true);
    }

    module i2c_mux_cutout() {
        cube([
            i2c_mux_cutout_width,
            i2c_mux_cutout_length,
            i2c_mux_cutout_depth
        ], center = true);

        translate([
            (i2c_mux_cutout_width - i2c_mux_cable_cutout_width) / 2,
            (i2c_mux_cutout_length + i2c_mux_cable_cutout_length) / 2,
            -(i2c_mux_cutout_depth - i2c_mux_cable_cutout_width) / 2
        ])
        cube([
            i2c_mux_cable_cutout_width,
            i2c_mux_cable_cutout_length,
            i2c_mux_cable_cutout_width
        ], center=true);

        translate([0,0, (i2c_mux_cutout_depth - i2c_mux_lid_depth)/ 2])
        cube([
            i2c_mux_cutout_width + 2 * i2c_mux_lid_offset,
            i2c_mux_cutout_length + 2 * i2c_mux_lid_offset,
            i2c_mux_lid_depth, 
        ], center = true);
    }

    module laser_cutout() {
        translate([0, laser_cutout_depth / 2, 0])
            cube([laser_cutout_width, laser_cutout_depth, laser_cutout_length], center = true);
        translate([0, laser_cable_lenght / 2 + laser_cutout_depth, (laser_cutout_length - laser_cable_width) / 2])
            cube([laser_cutout_width, laser_cable_lenght, laser_cable_width], center = true);
    }

    module floor_laser_cutout() {
        rotate([0, -90, 0])
            linear_extrude(laser_cutout_width, [1,0,0], center = true)
            polygon([
                [laser_cutout_length / 2, 0],
                [laser_cutout_length / 2, laser_cutout_depth],
                [- laser_cutout_length / 2, laser_cutout_depth + laser_floor_bottom_offset],
                [- laser_cutout_length / 2 - laser_floor_front_offset, 0]
            ]);
        translate([0, laser_cable_lenght / 2 + laser_cutout_depth, (laser_cutout_length - laser_cable_width) / 2])
            cube([laser_cutout_width, laser_cable_lenght, laser_cable_width], center = true);
    }

    module all_lasers_cutout() {
        translate([(front_width - laser_cutout_width) / 2 - laser_cutout_offset, - length / 2, laser_cutout_z_offset])
            laser_cutout();

        translate([- (front_width - laser_cutout_width) / 2 + laser_cutout_offset, - length / 2, laser_cutout_z_offset])
            floor_laser_cutout();

        mirror_copy([1,0,0])
        translate([battery_box_width / 2 , - length / 2 + front_cutout_depth + laser_cutout_width / 2 + laser_cutout_offset, laser_cutout_z_offset])
        rotate([0, 0, 90])
            laser_cutout();

        mirror_copy([1,0,0])
        translate([(battery_box_width + front_width) / 4  , (- length + front_cutout_depth) / 2 , laser_cutout_z_offset])
        rotate([0, 0, front_angle])
            laser_cutout();
    }

    difference() {
        union() {
            cube([width, length, height], center = true);

            translate([0, 0, (height + battery_box_height) / 2])
                cube([battery_box_width, length, battery_box_height], center = true);
        }
            
        mirror_copy([1, 0, 0]) {
            translate([battery_box_width / 2 - battery_box_rounding_r,0, height / 2 + battery_box_height - battery_box_rounding_r])
                top_rounding();
        }

        mirror_copy([1, 0, 0]) {
            side_cutouts();
        }

        mirror_copy([1, 0, 0]) {
            translate([(width - motor_length) / 2, length / 2 - motor_back_offset,
            - (height - motor_height) / 2])
            motor_cutouts();
        }
        
        translate([0, (length - battery_box_length) / 2 - battery_box_back_offset, (height - battery_box_depth) / 2])
            battery_box_cutout();
        
        translate([0,
                   (length - electronic_cutout_length) / 2 - battery_box_back_offset,
                   (height - electronic_cutout_depth) / 2 - battery_box_depth])
            electronic_cutout();

        translate([ (electronic_cutout_width - gyroscope_width) / 2 + gyroscope_offset,
                    (length - gyroscope_length) / 2 - battery_box_back_offset,
                    (height - gyroscope_depth) / 2 - battery_box_depth])
            gyroscope_cutout();

        translate([0,
                   - (length / 2 - front_cutout_depth - i2c_mux_cutout_wall_thick - i2c_mux_cutout_length / 2) - i2c_mux_cutout_front_offset,
                   (height / 2 + battery_box_height - i2c_mux_cutout_depth / 2)
        ])
        i2c_mux_cutout();

        all_lasers_cutout();

        translate([0,
                  (length - ball_wheel_length) / -2 + ball_wheel_front_offset,
                  (height - ball_wheel_depth) / -2
            ])
            ball_wheel_cutout();
    }
}

body();

translate([(body_width - motor_length) / 2,
            body_length / 2 - motor_back_offset,
            - (body_height - motor_height) / 2 - motor_height / 4])
    motor_holder();
    

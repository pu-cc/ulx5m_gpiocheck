`timescale 1ns / 1ps

module top (
    //input  ser_clk,
    input  clk_25mhz,
    output [27:2] gpio,
    input  btn3, btn2, btn1, pwr_btn,
    output [7:0] led,
    output [3:0] sd_dat,
    output sd_clk, sd_cmd,
    output fan_pwm,
    output [2:0] lvds1_d_p, lvds1_d_n,
    output lvds1_c_p, lvds1_c_n,
    output [3:0] lvds0_d_p, lvds0_d_n,
    output lvds0_c_p, lvds0_c_n,
    output [2:0] ddmio_tx_p, ddmio_tx_n,
    output ddmio_clk_p, ddmio_clk_n,
    output id_sd, id_sc
);

    wire clk270, clk180, clk90, clk0, usr_ref_out;
    wire usr_pll_lock_stdy, usr_pll_lock;

    CC_PLL #(
        .REF_CLK("25.0"),    // reference input in MHz
        .OUT_CLK("1.0"),     // pll output frequency in MHz
        .LOW_JITTER(1),      // 0: disable, 1: enable low jitter mode
        .CI_FILTER_CONST(2), // optional CI filter constant
        .CP_FILTER_CONST(4)  // optional CP filter constant
    ) pll_inst (
        .CLK_REF(clk_25mhz), .CLK_FEEDBACK(1'b0), .USR_CLK_REF(1'b0),
        .USR_LOCKED_STDY_RST(1'b0), .USR_PLL_LOCKED_STDY(usr_pll_lock_stdy), .USR_PLL_LOCKED(usr_pll_lock),
        .CLK270(clk270), .CLK180(clk180), .CLK90(clk90), .CLK0(clk0), .CLK_REF_OUT(usr_ref_out)
    );

    assign gpio[27:2] = {26{clk0}};
    assign led[7:0] = {4'hf, btn3, btn2, btn1, pwr_btn};
    assign sd_dat[3:0] = {4{clk0}};
    assign {sd_clk, sd_cmd} = {2{clk0}};
    assign fan_pwm = clk0;

    assign lvds1_d_p[2:0] = {3{ clk0}};
    assign lvds1_d_n[2:0] = {3{ clk0}}; // do not invert *_n: 150R termination
    assign {lvds1_c_n, lvds1_c_p} = { clk0, clk0}; // do not invert *_n: 150R termination

    assign lvds0_d_p[3:0] = {4{ clk0}};
    assign lvds0_d_n[3:0] = {4{ clk0}}; // do not invert *_n: 150R termination
    assign {lvds0_c_n, lvds0_c_p} = { clk0, clk0};

    assign ddmio_tx_p[2:0] = {3{ clk0}};
    assign ddmio_tx_n[2:0] = {3{~clk0}};
    assign {ddmio_clk_n, ddmio_clk_p} = {~clk0, clk0};

endmodule

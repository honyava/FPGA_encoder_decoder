module hamming_encoder_11_7 (
    input [6:0] data_in,   // Входные 7-битные данные
    input areset_n,
    output reg [10:0] data_out // Выходные 11-битные данные с контрольными битами
);

    // Промежуточные переменные для контрольных битов
    wire [3:0] s;

    always@(data_in or negedge areset_n) begin

        if(!areset_n) data_out <= 0;
        else begin
            // Кодирование данных с добавлением контрольных битов
            data_out[0] <= s[0];       // Контрольный бит 1
            data_out[1] <= s[1];       // Контрольный бит 2
            data_out[2] <= data_in[0]; // Информационный бит
            data_out[3] <= s[2];       // Контрольный бит 3
            data_out[4] <= data_in[1]; // Информационный бит
            data_out[5] <= data_in[2]; // Информационный бит
            data_out[6] <= data_in[3]; // Информационный бит
            data_out[7] <= s[3];       // Контрольный бит 4
            data_out[8] <= data_in[4]; // Информационный бит
            data_out[9] <= data_in[5]; // Информационный бит
            data_out[10] <= data_in[6]; // Информационный бит

        end

    end

    assign s[0] = ^(data_in & 7'b1011_011);
    assign s[1] = ^(data_in & 7'b1101_101);
    assign s[2] = ^(data_in & 7'b0001_110);
    assign s[3] = ^(data_in & 7'b1110_000);

endmodule
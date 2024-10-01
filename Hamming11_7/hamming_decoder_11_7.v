module hamming_decoder_11_7 (
    input [10:0] encoded_in,   // Входное 11-битное закодированное слово
    input areset_n,            // Асинхронный сброс
    input clk,                 // Тактовый сигнал
    output reg [6:0] data_out, // Выходные 7-битные декодированные данные
    output reg error_flag,     // Флаг обнаружения ошибки
    output reg corrected_flag  // Флаг исправленной ошибки
);

    // Промежуточные переменные для синдрома и контрольных битов
    reg [3:0] syndrome;    // Синдром ошибки
    reg [10:0] corrected;  // Исправленное слово

    // Извлечение контрольных битов и данных
    wire s1 = encoded_in[0];   // Контрольный бит 1
    wire s2 = encoded_in[1];   // Контрольный бит 2
    wire s4 = encoded_in[3];   // Контрольный бит 4
    wire s8 = encoded_in[7];   // Контрольный бит 8

    wire [6:0] data_in = {encoded_in[10], encoded_in[9], encoded_in[8], encoded_in[6], encoded_in[5], encoded_in[4], encoded_in[2]}; // Восстановление исходных 7 бит данных

    always @(posedge clk or negedge areset_n) begin
        if (!areset_n) begin
            data_out <= 7'b0;
            error_flag <= 0;
            corrected_flag <= 0;
        end else begin
            // Вычисление синдрома
            syndrome[0] <= s1 ^ encoded_in[2] ^ encoded_in[4] ^ encoded_in[6] ^ encoded_in[8] ^ encoded_in[10];
            syndrome[1] <= s2 ^ encoded_in[2] ^ encoded_in[5] ^ encoded_in[6] ^ encoded_in[9] ^ encoded_in[10];
            syndrome[2] <= s4 ^ encoded_in[4] ^ encoded_in[5] ^ encoded_in[6];
            syndrome[3] <= s8 ^ encoded_in[8] ^ encoded_in[9] ^ encoded_in[10];

            // Если синдром не равен 0, значит есть ошибка
            if (syndrome != 4'b0000) begin
                error_flag <= 1;

                // Определение позиции ошибки (если синдром указывает на одно-битную ошибку)
                corrected <= encoded_in;
                corrected[syndrome] <= ~corrected[syndrome]; // Инвертируем бит с ошибкой

                corrected_flag <= 1;
                data_out <= {corrected[10], corrected[9], corrected[8], corrected[6], corrected[5], corrected[4], corrected[2]}; // Извлечение исправленных данных
            end else begin
                // Если ошибок нет
                error_flag <= 0;
                corrected_flag <= 0;
                data_out <= data_in;  // Передаем исходные данные
            end
        end
    end

endmodule

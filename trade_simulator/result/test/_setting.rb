# coding: Windows-31J

require "./lib/base"
require "./lib/text_to_stock"
require "./lib/trading_system"
require "./lib/recorder"
require "pp"

# ���f�[�^�I�u�W�F�N�g�𐶐�����
@data = TextToStock.new(stock_list: "tosho_list.txt")
# @data.from = "2010/01/01"
# @data.to = "2011/09/01"


# �g���[�h�V�X�e�����쐬����
@trading_system = TradingSystem.new ({
                    # �ړ����Ϙ������ɂ��d�|��
                    # 20���ړ����ς���5%���ꂽ����t���Ŏd�|����
                    entries: EstrangementEntry.new(span: 20, rate: 5),
                    exits: [
                        # �X�g�b�v���C���ɂ���d����������
                        StopOutExit.new,
                        # �ړ����Ϙ������ɂ���d����
                        # 20���ړ����ς���3%�ȓ��ɖ߂������d����������
                        EstrangementExit.new(span:20, rate: 3)
                    ],
                    # ATR�ɂ��X�g�b�v
                    # �d�|���l����20��ATR�̂Ƃ���ɃX�g�b�v���C����ݒ肷��
                    stops: AverageTrueRangeStop.new(span: 20),
                    # �ړ����ς̕����ɂ��t�B���^�[
                    # �����͈ړ����ς��㏸���̂Ƃ��̂݁A
                    # ����͈ړ����ς����~���̂Ƃ��݂̂�������
                    filters: MovingAverageDirectionFilter.new(span: 30)
                  })

# �g���[�h�V�X�e���𓮂���
def simulate(code)
    # ��������̃f�[�^���擾����
    stock = @data.generate_stock(code)
    # �V�X�e���Ɋ��I�u�W�F�N�g��o�^����
    @trading_system.set_stock(stock)
    # �V�X�e���̊e���[���Ɏw�W��o�^����
    @trading_system.calculate_indicators
    # 1�񂸂̃g���[�h
    trade = nil
    # ���ׂẴg���[�h���L�^����
    trades = []
    # stock�ɓo�^����Ă�����t�̕��������[�v
    stock.prices.size.times do |i|
        # �|�W�V����������ꍇ
        if trade
            @trading_system.set_stop(trade, i)
            trade.length += 1
        end
        # �|�W�V�������Ȃ��ꍇ
        unless trade
            # �d�|�����邩�`�F�b�N����
            trade = @trading_system.check_entry(i)
            # �Œ�P���Ŏd�|����
            trade.volume = stock.unit if trade
        end
        if trade
            # Exit���[���ɂЂ��������ĂȂ����`�F�b�N����
            @trading_system.check_exit(trade, i)
            # ��d����������L�^���ďI��
            if trade.closed?
                trades << trade
                trade = nil
            end
        end
    end
    trades
end

# �L�^�p�X�N���v�g
recorder = Recorder.new
recorder.record_dir = "result/test"
# �L�^�p�t�H���_�����
recorder.create_record_folder
# __FILE__�͂��̃t�@�C���̂���
recorder.record_setting(__FILE__)

# �V�~�����[�V��������
results = [1301,1332,1333,1352,1376,1377,1379,1384,1413,7212,8604].map do |code|
    simulate(code)
end

# �P�������̌��ʂ��o��
results.each do |trades|
    recorder.record_a_stock(trades)
end

# �������Ƃ̓��v�f�[�^���o��
recorder.record_stats_for_each_stock(results)
# �܂Ƃ߂����v�f�[�^���o��
recorder.record_stats(results)

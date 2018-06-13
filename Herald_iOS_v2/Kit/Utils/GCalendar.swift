import Foundation

/// 格里高利历中的简单日期/时间计算类实现。
// 该类实现了对如下流程的处理：
// 1) 使用者初始化一个时间对象
// 2) 使用者对该时间中不同单位的值进行设置
// 3) 由一个 DateComponents 对象负责记录这些更改
// 4) 由 Calendar 对象实时将上面记录下来的更改同步到一个 Date 对象中
// 5) 再由这个 Calendar 对象实时将这个 Date 对象中的结果转换成另外一个 DateComponents 对象
// 6) 当使用者再来查询不同单位的值时，由这个新生成的 DateComponents 对象负责返回结果

// 通过上述流程，实现将使用者对时间字段的修改与最终的计算结果分离开来，保证计算结果始终按照正确的历法生成，而不会因为用户修改而导致自相矛盾
public class GCalendar : CustomDebugStringConvertible {
    
    /// 从系统本身获取到的历法设置
    private var calendar : Calendar
    
    /// 只包含所需时间单位的时间字段表，用于记录使用者对时间字段的更改
    // 为防止日期与星期自相矛盾导致计算失败，该对象不允许存储星期值，相应地，也不允许用户直接更改星期值。
    // 它的单位始终是 unit 对象，该 unit 对象的所有可能的取值参见常数组 PRECISION_UNITS。
    private var srcComp : DateComponents
    
    /// 该 Date 对象应当始终表示这个 GCalendar 对象所代表的时间
    // 当用户对上面的 components 做了修改后，应根据历法，实时将这些更改同步到这里
    private var date : Date
    
    /// 包含完整时间单位的时间字段集，用于将计算好的时间结果拆分成不同单位进行输出
    // date 和 dstComp 都是符合历法的计算结果，它们同时负责响应使用者的查询需求
    // 若使用者要查询年、月、日、星期等，从 dstComp 获取相应的字段并返回；
    // 若使用者要获得时间戳，从 date 获取时间戳并返回。
    private var dstComp : DateComponents
    
    /// 所需的时间单位集合，取值被限制在下面的PRECISION_UNITS数组中
    private var unit : Set<Calendar.Component>
    
    /// 全部单位
    private let allUnits : Set<Calendar.Component> = [
        .calendar,
        .day,
        .era,
        .hour,
        .minute,
        .month,
        .quarter,
        .second,
        .timeZone,
        .weekday,
        .weekdayOrdinal,
        .weekOfMonth,
        .weekOfYear,
        .year,
        .yearForWeekOfYear
    ]
    
    /// 由使用者设置的时间精确度
    public enum GCalendarPrecision: Int {
        /// 精确到年
        case Year
        /// 精确到月
        case Month
        /// 精确到天
        case Day
        /// 精确到小时
        case Hour
        /// 精确到分钟
        case Minute
        /// 精确到秒
        case Second
    }
    
    /// 表示星期（从周日开始）的枚举值，星期虽不可设置，但可以被使用者查询到。遵守可转换成字符串的协议。
    public enum DayOfWeekFromSunday : Int, CustomDebugStringConvertible {
        case Sunday
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        
        public var debugDescription: String {
            return ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"][self.rawValue]
        }
    }
    
    /// 表示星期（从周一开始）的枚举值，星期虽不可设置，但可以被使用者查询到。遵守可转换成字符串的协议。
    public enum DayOfWeekFromMonday : Int, CustomDebugStringConvertible {
        case Monday
        case Tuesday
        case Wednesday
        case Thursday
        case Friday
        case Saturday
        case Sunday
        
        public var debugDescription: String {
            return ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"][self.rawValue]
        }
    }
    
    /// 六种精确度对应的六种单位集合
    public static let PRECISION_UNITS : [Set<Calendar.Component>] = [
        // 精确到年
        [.year],
        // 精确到月
        [.year, .month],
        // 精确到天
        [.year, .month, .day, .weekOfYear, .weekOfMonth, .weekday],
        // 精确到小时
        [.year, .month, .day, .weekOfYear, .weekOfMonth, .weekday, .hour],
        // 精确到分钟
        [.year, .month, .day, .weekOfYear, .weekOfMonth, .weekday, .hour, .minute],
        // 精确到秒
        [.year, .month, .day, .weekOfYear, .weekOfMonth, .weekday, .hour, .minute, .second]
    ]
    
    /// 用指定的精确度初始化时间对象
    public init (_ precision : GCalendarPrecision) {
        // 设置单位
        self.unit = GCalendar.PRECISION_UNITS[precision.rawValue]
        // 获取系统历法设置
        calendar = Calendar.current
        // 用系统时间初始化 srcComp，此时超过精确度范围的字段将被自动截断
        srcComp = calendar.dateComponents(unit, from: Date())
        
        // 将精确度范围内的时间值同步到 date
        date = calendar.date(from: srcComp)!
        // 将 date 的时间值同步到 dstComp
        dstComp = calendar.dateComponents(allUnits, from: date)
    }
    
    /// 复制构造函数
    public init (_ src : GCalendar) {
        self.unit = src.unit
        self.calendar = src.calendar
        self.srcComp = src.srcComp
        self.date = src.date
        self.dstComp = src.dstComp
    }
    
    /// 默认构造函数，缺省精确度为秒
    public convenience init () {
        self.init(.Second)
    }
    
    /// 构造函数，直接构造指定年月日的时间，自动精确到天
    public convenience init (_ y: Int, _ M: Int, _ d: Int) {
        self.init(.Day)
        setDate(y, M, d)
    }
    
    /// 构造函数，直接构造指定年月日时分秒的时间，自动精确到秒
    public convenience init (_ y: Int, _ M: Int, _ d: Int, _ h: Int, _ m: Int, _ s: Int) {
        self.init(.Second)
        setDate(y, M, d)
        setTime(h, m, s)
    }
    
    /// 构造函数，通过 Date 构造时间
    public convenience init (_ date: Date) {
        self.init()
        rawTime = Int64(date.timeIntervalSince1970)
    }
    
    /// 构造函数，根据字符串构造对应的时间，允许-/:. 等分隔符，
    /// 根据分割出来的子串个数，依次填到年/月/日/时/分/秒中
    public convenience init (_ src : String) {
        let int = src
            .replacingOccurrences(of: "/", with: "-")
            .replacingOccurrences(of: ":", with: "-")
            .replacingOccurrences(of: ".", with: "-")
            .replacingOccurrences(of: " ", with: "-")
            .replacingOccurrences(of: "年", with: "-")
            .replacingOccurrences(of: "月", with: "-")
            .replacingOccurrences(of: "日", with: "-")
            .replacingOccurrences(of: "--", with: "-")
            .components(separatedBy: "-").map { s -> Int in
                Int(s) == nil ? 0 : Int(s)!
        }
        self.init(GCalendarPrecision(rawValue: min(5, max(0, int.count - 1)))!)
        
        if int.count > 0 { self.year = max(1970, int[0]) }
        if int.count > 1 { self.month = max(1, int[1]) }
        if int.count > 2 { self.day = max(1, int[2]) }
        if int.count > 3 { self.hour = int[3] }
        if int.count > 4 { self.minute = int[4] }
        if int.count > 5 { self.second = int[5] }
    }
    
    /// 立即同步 srcComp 中的更改到 date 和 dstComp
    private func sync() {
        date = calendar.date(from: srcComp)!
        dstComp = calendar.dateComponents(allUnits, from: date)
    }
    
    /// 反向同步 date 到 srcComp 并更新 dstComp
    private func backSync() {
        srcComp = calendar.dateComponents(unit, from: date)
        dstComp = calendar.dateComponents(allUnits, from: date)
    }
    
    /// 直接设置日期
    public func setDate (_ year : Int, _ month : Int, _ day : Int) {
        self.year = year
        self.month = month
        self.day = day
    }
    
    /// 直接设置时间
    public func setTime (_ hour : Int, _ minute : Int, _ second : Int) {
        self.hour = hour
        self.minute = minute
        self.second = second
    }
    
    /// 年份的设置和获取
    public var year : Int {
        get {
            return dstComp.year ?? 1990
        } set (value) {
            srcComp.year = value
            sync()
        }
    }
    
    /// 月份的设置和获取
    public var month : Int {
        get {
            return dstComp.month ?? 1
        } set (value) {
            srcComp.month = value
            sync()
        }
    }
    
    /// 日期的设置和获取
    public var day : Int {
        get {
            return dstComp.day ?? 1
        } set (value) {
            srcComp.day = value
            sync()
        }
    }
    
    /// 周数的获取
    public var weekOfYear : Int {
        get {
            return dstComp.weekOfYear ?? 1
        }
    }
    
    /// 星期的获取（0为周日，1为周一，以此类推）
    public var dayOfWeekFromSunday : DayOfWeekFromSunday {
        get {
            // dstComp.weekday 是以1为周日，2为周一，以此类推，因此要减1
            return DayOfWeekFromSunday(rawValue: ((dstComp.weekday ?? 1) - 1) % 7)!
        }
    }
    
    /// 星期的获取（0为周一，1为周二，以此类推）
    public var dayOfWeekFromMonday : DayOfWeekFromMonday {
        get {
            // dstComp.weekday 是以1为周日，2为周一，以此类推，因此要+5
            return DayOfWeekFromMonday(rawValue: ((dstComp.weekday ?? 1) + 5) % 7)!
        }
    }
    
    /// 小时的设置和获取
    public var hour : Int {
        get {
            return dstComp.hour ?? 0
        } set (value) {
            srcComp.hour = value
            sync()
        }
    }
    
    /// 分钟的设置和获取
    public var minute : Int {
        get {
            return dstComp.minute ?? 0
        } set (value) {
            srcComp.minute = value
            sync()
        }
    }
    
    /// 秒钟的设置和获取
    public var second : Int {
        get {
            return dstComp.second ?? 0
        } set (value) {
            srcComp.second = value
            sync()
        }
    }
    
    /// 用字符串表示
    public var debugDescription: String {
        get {
            return String(format: "%d-%02d-%02d %02d:%02d:%02d \(dayOfWeekFromSunday)", year, month, day, hour, minute, second)
        }
    }
    
    /// 时间戳的设置和获取
    public var rawTime : Int64 {
        get {
            return Int64(date.timeIntervalSince1970)
        } set (value) {
            date = Date(timeIntervalSince1970: Double(value))
            backSync()
        }
    }
    
    public func getDate() -> Date {
        return date
    }
}

/// 各种运算符重载
// 用来代替赋值
func << (left: GCalendar, right: GCalendar) -> GCalendar {
    left.rawTime = right.rawTime
    return left
}

// 自加一段时间
func += (left: GCalendar, right: Int) {
    left.rawTime = left.rawTime + right
}

// 加上一段时间
func + (left: GCalendar, right: Int) -> GCalendar {
    let ret = GCalendar(left)
    ret.rawTime = ret.rawTime + right
    return ret
}

// 自减一段时间
func -= (left: GCalendar, right: Int) {
    left.rawTime = left.rawTime - right
}

// 减去一段时间
func - (left: GCalendar, right: Int) -> GCalendar {
    let ret = GCalendar(left)
    ret.rawTime = ret.rawTime - right
    return ret
}

// 求时间差
func - (left: GCalendar, right: GCalendar) -> Int {
    return left.rawTime - right.rawTime
}

// 比较大小
func > (left: GCalendar, right: GCalendar) -> Bool {
    return left.rawTime > right.rawTime
}

// 比较大小
func < (left: GCalendar, right: GCalendar) -> Bool {
    return right > left
}

// 比较大小
func >= (left: GCalendar, right: GCalendar) -> Bool {
    return !(left < right)
}

// 比较大小
func <= (left: GCalendar, right: GCalendar) -> Bool {
    return !(left > right)
}

// 比较大小
func == (left: GCalendar, right: GCalendar) -> Bool {
    return left >= right && right >= left
}

// 比较大小
func != (left: GCalendar, right: GCalendar) -> Bool {
    return left < right || right < left
}


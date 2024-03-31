//
//  CalendarTest.swift
//  CalendarWidgetHomeExtension
//
//  Created by air on 2024/03/31.
//

import SwiftUI

struct CalendarTest: View {
    
    var body: some View {
        VStack(alignment:.leading) {
            CalendarHeader()
            CalendarBody()
        }
        .frame(maxWidth:.infinity,maxHeight:.infinity,alignment:.topLeading)
        .background(Color.white)
    }
}



///
/// @ Header
///
struct CalendarHeader : View {
    var month = Date().month
    var body: some View {
        HStack {
            Text("\(month)월")
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .foregroundColor(.black)
            Spacer()
            Button(action: {
                        // 버튼 클릭 시 실행할 액션
                        print("플러스 버튼 클릭됨")
                    }) {
                        Image(systemName: "plus").frame(width: 22,height: 22)
                            .foregroundColor(.gray) // 플러스 아이콘
                    }
                    .buttonStyle(.borderless)
            
        }.padding(EdgeInsets(top: 9, leading: 18, bottom: 9, trailing: 18))

        
    }
}
///
/// @ Calendar Body
///
struct CalendarBody: View {
    // 요일의 배열
    let daysInWeek = ["일", "월", "화", "수", "목", "금", "토"]

    
    // 날짜 포맷터
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    // 표시할 날짜
    var date: Date {
        let components = DateComponents(year: Date().year, month: Date().month, day: 1)
        return Calendar.current.date(from: components)!
    }
    
    var body: some View {
        VStack {
            // 달력 표시
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: 20) {
                // 요일 표시
                ForEach(daysInWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 14))
                        .fontWeight(.regular)
                        .foregroundColor(day == "일" ?.red:.black)
       
                }
                // 날짜 표시
                ForEach(getDatesOfMonth(), id: \.self) { date in
                    VStack{
                        Text("\(date.day)")
                            .font(.system(size: 12))
                            .fontWeight(.regular)
                            // 날짜 색상 설정: 오늘 -> 흰색, 일요일 -> 빨간색, 기타 -> 검은색
                            .foregroundColor(Calendar.current.isDate(date, inSameDayAs: Date()) ? Color.blue :
                            (Calendar.current.component(.weekday, from: date) == 1 ? .red : .black))
                    }
                       
                }
            }
        }.padding(.horizontal,2)
    
    }
    
    // 해당 월의 모든 날짜를 가져오기
    func getDatesOfMonth() -> [Date] {
        guard let range = Calendar.current.range(of: .day, in: .month, for: date) else { return [] }
        // 현재 달의 모든 날짜 생성
        
        let days = range.compactMap { day -> Date? in
            Calendar.current.date(from: DateComponents(year: date.year, month: date.month, day: day))
        }

        guard let firstDateOfMonth = days.first, let lastDateOfMonth = days.last else { return [] }

        // 첫 날짜의 요일 계산
        let weekdayOfFirstDate = Calendar.current.component(.weekday, from: firstDateOfMonth)
        
        // 첫 주에 필요한 이전 달의 날짜 수 계산
        let needPreviousDays = weekdayOfFirstDate == 1 ? 6 : weekdayOfFirstDate - Calendar.current.firstWeekday

        // 이전 달의 날짜 생성
        let previousMonthDays = (0..<needPreviousDays).reversed().compactMap { day -> Date? in
            Calendar.current.date(byAdding: .day, value: -(day + 1), to: firstDateOfMonth)
        }
        // 다음 달의 날짜 계산을 위한 준비
        let totalDaysCount = needPreviousDays + range.count
  
        let needNextDays = (7 - totalDaysCount % 7) % 7

        // 다음 달의 날짜 생성
        let nextMonthDays = (1...needNextDays).compactMap { day -> Date? in
            Calendar.current.date(byAdding: .day, value: day, to: lastDateOfMonth)
        }

        // 최종 날짜 배열 반환
          return previousMonthDays + days + nextMonthDays
        
    }
}

///
/// @ Date Extension
///

extension Date {
    // 년도 가져오기
    var year: Int {
        Calendar.current.component(.year, from: self)
    }
    // 월 가져오기
    var month: Int {
        Calendar.current.component(.month, from: self)
    }
    // 일 가져오기
    var day: Int {
        Calendar.current.component(.day, from: self)
    }
   
// 년도와 월을 문자열로 변환하기
    var yearMonth: String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy년 MM월"
    return formatter.string(from: self)
    }
// 오늘인지 확인하기
    var isToday: Bool {
    Calendar.current.isDateInToday(self)
    }
}




